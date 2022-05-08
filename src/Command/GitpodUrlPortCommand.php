<?php

declare(strict_types=1);

namespace Shopware\Production\Command;

use Nyholm\Psr7\Factory\Psr17Factory;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class GitpodUrlPortCommand extends Command
{
    protected static $defaultName = 'gp:url:port';

    protected function configure()
    {
        $this->addArgument('port', InputArgument::REQUIRED);
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $port = (int) $input->getArgument('port');
        $workspaceUri = (new Psr17Factory())->createUri(\trim(`gp url`));
        $host = \sprintf('%s-%s', $port, $workspaceUri->getHost());

        $output->writeln($workspaceUri->withHost($host));

        return Command::SUCCESS;
    }
}
